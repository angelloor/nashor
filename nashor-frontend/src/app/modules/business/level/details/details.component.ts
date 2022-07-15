import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { levelProfile } from '../../level-profile/level-profile.data';
import { LevelProfileService } from '../../level-profile/level-profile.service';
import { LevelProfile } from '../../level-profile/level-profile.types';
import { levelStatus } from '../../level-status/level-status.data';
import { LevelStatusService } from '../../level-status/level-status.service';
import { LevelStatus } from '../../level-status/level-status.types';
import { template } from '../../template/template.data';
import { TemplateService } from '../../template/template.service';
import { Template } from '../../template/template.types';
import { LevelService } from '../level.service';
import { Level } from '../level.types';
import { LevelListComponent } from '../list/list.component';

@Component({
  selector: 'level-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class LevelDetailsComponent implements OnInit {
  id_company: string = '';

  listTemplate: Template[] = [];
  selectedTemplate: Template = template;

  listLevelProfile: LevelProfile[] = [];
  selectedLevelProfile: LevelProfile = levelProfile;

  listLevelStatus: LevelStatus[] = [];
  selectedLevelStatus: LevelStatus = levelStatus;

  nameEntity: string = 'Nivel';
  private data!: AppInitialData;

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  level!: Level;
  levelForm!: FormGroup;
  private levels!: Level[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _levelListComponent: LevelListComponent,
    private _levelService: LevelService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _templateService: TemplateService,
    private _levelProfileService: LevelProfileService,
    private _levelStatusService: LevelStatusService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Open the drawer
     */
    this._levelListComponent.matDrawer.open();
    /**
     * Create the level form
     */
    this.levelForm = this._formBuilder.group({
      id_level: [''],
      id_company: [''],
      id_template: ['', [Validators.required]],
      id_level_profile: ['', [Validators.required]],
      id_level_status: ['', [Validators.required]],
      name_level: ['', [Validators.required, Validators.maxLength(100)]],
      description_level: ['', [Validators.required, Validators.maxLength(250)]],
    });
    /**
     * Get the levels
     */
    this._levelService.levels$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((levels: Level[]) => {
        this.levels = levels;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the level
     */
    this._levelService.level$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((level: Level) => {
        /**
         * Open the drawer in case it is closed
         */
        this._levelListComponent.matDrawer.open();
        /**
         * Get the level
         */
        this.level = level;

        // Template
        this._templateService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((templates: Template[]) => {
            this.listTemplate = templates;

            this.selectedTemplate = this.listTemplate.find(
              (item) =>
                item.id_template == this.level.template.id_template.toString()
            )!;
          });

        // LevelProfile
        this._levelProfileService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_profiles: LevelProfile[]) => {
            this.listLevelProfile = level_profiles;

            this.selectedLevelProfile = this.listLevelProfile.find(
              (item) =>
                item.id_level_profile ==
                this.level.level_profile.id_level_profile.toString()
            )!;
          });

        // LevelStatus
        this._levelStatusService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_statuss: LevelStatus[]) => {
            this.listLevelStatus = level_statuss;

            this.selectedLevelStatus = this.listLevelStatus.find(
              (item) =>
                item.id_level_status ==
                this.level.level_status.id_level_status.toString()
            )!;
          });

        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.levelForm.patchValue({
      ...this.level,
      id_company: this.level.company.id_company,
      id_template: this.level.template.id_template,
      id_level_profile: this.level.level_profile.id_level_profile,
      id_level_status: this.level.level_status.id_level_status,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._levelListComponent.matDrawer.close();
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the level
   */
  updateLevel(): void {
    /**
     * Get the level
     */
    const id_user_ = this.data.user.id_user;
    let level = this.levelForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    level = {
      ...level,
      id_user_: parseInt(id_user_),
      id_level: parseInt(level.id_level),
      company: {
        id_company: parseInt(level.id_company),
      },
      template: {
        id_template: parseInt(level.id_template),
      },
      level_profile: {
        id_level_profile: parseInt(level.id_level_profile),
      },
      level_status: {
        id_level_status: parseInt(level.id_level_status),
      },
    };
    /**
     * Update
     */
    this._levelService
      .update(level)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_level: Level) => {
          if (_level) {
            this._notificationService.success(
              'Nivel actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          this._notificationService.error(
            !error.error
              ? '¡Error interno!, consulte al administrador.'
              : !error.error.description
              ? '¡Error interno!, consulte al administrador.'
              : error.error.description
          );
        },
      });
  }
  /**
   * Delete the level
   */
  deleteLevel(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar nivel',
        message:
          '¿Estás seguro de que deseas eliminar esta nivel? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current level's id
           */
          const id_user_ = this.data.user.id_user;
          const id_level = this.level.id_level;
          /**
           * Get the next/previous level's id
           */
          const currentIndex = this.levels.findIndex(
            (item) => item.id_level === id_level
          );

          const nextIndex =
            currentIndex + (currentIndex === this.levels.length - 1 ? -1 : 1);
          const nextId =
            this.levels.length === 1 && this.levels[0].id_level === id_level
              ? null
              : this.levels[nextIndex].id_level;
          /**
           * Delete
           */
          this._levelService
            .delete(id_user_, id_level)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the level wasn't deleted...
                   */
                  this._notificationService.success(
                    'Nivel eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next level if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
}
