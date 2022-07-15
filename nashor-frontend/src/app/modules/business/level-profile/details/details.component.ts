import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { cloneDeep } from 'lodash';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { OfficialService } from '../../official/official.service';
import { Official } from '../../official/official.types';
import { LevelProfileOfficialService } from '../level-profile-official/level-profile-official.service';
import { LevelProfileOfficial } from '../level-profile-official/level-profile-official.types';
import { LevelProfileService } from '../level-profile.service';
import { LevelProfile } from '../level-profile.types';
import { LevelProfileListComponent } from '../list/list.component';

@Component({
  selector: 'level-profile-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class LevelProfileDetailsComponent implements OnInit {
  nameEntity: string = 'Perfil del nivel';
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
  levelProfile!: LevelProfile;
  levelProfileForm!: FormGroup;
  private levelProfiles!: LevelProfile[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  categoriesOfficial: Official[] = [];
  isSelectedAll: boolean = false;

  levelProfileOfficial: LevelProfileOfficial[] = [];
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _levelProfileListComponent: LevelProfileListComponent,
    private _levelProfileService: LevelProfileService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _levelProfileOfficialService: LevelProfileOfficialService,
    private _officialService: OfficialService
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
    });
    /**
     * Open the drawer
     */
    this._levelProfileListComponent.matDrawer.open();
    /**
     * Create the levelProfile form
     */
    this.levelProfileForm = this._formBuilder.group({
      id_level_profile: [''],
      id_company: [''],
      name_level_profile: [
        '',
        [Validators.required, Validators.maxLength(100)],
      ],
      description_level_profile: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      officials: this._formBuilder.array([]),
    });
    /**
     * Get the levelProfiles
     */
    this._levelProfileService.levelProfiles$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((levelProfiles: LevelProfile[]) => {
        this.levelProfiles = levelProfiles;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the levelProfile
     */
    this._levelProfileService.levelProfile$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((levelProfile: LevelProfile) => {
        /**
         * Open the drawer in case it is closed
         */
        this._levelProfileListComponent.matDrawer.open();
        /**
         * Get the levelProfile
         */
        this.levelProfile = levelProfile;

        /**
         * byLevelProfileRead
         */
        this._levelProfileOfficialService
          .byLevelProfileRead(this.levelProfile.id_level_profile)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();

        this._officialService
          .queryRead('*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_officials: Official[]) => {
            this.categoriesOfficial = _officials;
            /**
             * Subscribe
             */
            this._levelProfileOfficialService.levelProfileOfficials$
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe((_levelProfileOfficials: LevelProfileOfficial[]) => {
                this.levelProfileOfficial = _levelProfileOfficials;
                if (
                  this.levelProfileOfficial.length ==
                  this.categoriesOfficial.length
                ) {
                  this.isSelectedAll = true;
                } else {
                  this.isSelectedAll = false;
                }
                /**
                 * Filter select
                 */
                /**
                 * Reset the selection
                 * 1) add attribute isSelected
                 * 2) [disabled]="entity.isSelected" in mat-option
                 */
                this.categoriesOfficial.map((item, index) => {
                  item = {
                    ...item,
                    isSelected: false,
                  };
                  this.categoriesOfficial[index] = item;
                });

                let filterCategoriesOfficials: Official[] = cloneDeep(
                  this.categoriesOfficial
                );
                /**
                 * Selected Items
                 */
                this.levelProfileOfficial.map((itemOne) => {
                  /**
                   * All Items
                   */
                  filterCategoriesOfficials.map((itemTwo, index) => {
                    if (itemTwo.id_official == itemOne.official!.id_official) {
                      itemTwo = {
                        ...itemTwo,
                        isSelected: true,
                      };

                      filterCategoriesOfficials[index] = itemTwo;
                    }
                  });
                });

                this.categoriesOfficial = filterCategoriesOfficials;
                /**
                 * Filter select
                 */

                /**
                 * Clear the officials form arrays
                 */
                (this.levelProfileForm.get('officials') as FormArray).clear();

                const officialsFormGroups: any = [];

                /**
                 * Iterate through them
                 */
                this.levelProfileOfficial.forEach(
                  (_levelProfileOfficial, index: number) => {
                    /**
                     * Create an official form group
                     */
                    officialsFormGroups.push(
                      this._formBuilder.group({
                        id_level_profile_official: [
                          _levelProfileOfficial.id_level_profile_official,
                        ],
                        id_official: [
                          {
                            value: _levelProfileOfficial.official.id_official,
                            disabled:
                              this.levelProfileOfficial.length != index + 1 ||
                              this.isSelectedAll,
                          },
                        ],
                        level_profile: [_levelProfileOfficial.level_profile],
                        official: [_levelProfileOfficial.official],
                        official_modifier: [
                          _levelProfileOfficial.official_modifier,
                        ],
                      })
                    );
                  }
                );

                /**
                 * Add the officials form groups to the officials form array
                 */
                officialsFormGroups.forEach((officialsFormGroup: any) => {
                  (this.levelProfileForm.get('officials') as FormArray).push(
                    officialsFormGroup
                  );
                });
              });
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
  get formArrayOfficials(): FormArray {
    return this.levelProfileForm.get('officials') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.levelProfileForm.patchValue({
      ...this.levelProfile,
      id_company: this.levelProfile.company.id_company,
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
    return this._levelProfileListComponent.matDrawer.close();
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
   * Update the levelProfile
   */
  updateLevelProfile(): void {
    /**
     * Get the levelProfile
     */
    const id_user_ = this.data.user.id_user;
    let levelProfile = this.levelProfileForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    levelProfile = {
      ...levelProfile,
      id_user_: parseInt(id_user_),
      id_level_profile: parseInt(levelProfile.id_level_profile),
      company: {
        id_company: parseInt(levelProfile.id_company),
      },
    };
    /**
     * Update
     */
    this._levelProfileService
      .update(levelProfile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_levelProfile: LevelProfile) => {
          if (_levelProfile) {
            this._notificationService.success(
              'Perfil del nivel actualizada correctamente'
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
   * Delete the levelProfile
   */
  deleteLevelProfile(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar perfil del nivel',
        message:
          '¿Estás seguro de que deseas eliminar esta perfil del nivel? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current levelProfile's id
           */
          const id_user_ = this.data.user.id_user;
          const id_level_profile = this.levelProfile.id_level_profile;
          /**
           * Get the next/previous levelProfile's id
           */
          const currentIndex = this.levelProfiles.findIndex(
            (item) => item.id_level_profile === id_level_profile
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.levelProfiles.length - 1 ? -1 : 1);
          const nextId =
            this.levelProfiles.length === 1 &&
            this.levelProfiles[0].id_level_profile === id_level_profile
              ? null
              : this.levelProfiles[nextIndex].id_level_profile;
          /**
           * Delete
           */
          this._levelProfileService
            .delete(id_user_, id_level_profile)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the levelProfile wasn't deleted...
                   */
                  this._notificationService.success(
                    'Perfil del nivel eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next levelProfile if available
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
  /**
   * addOfficialField
   */
  addOfficialField(): void {
    const id_user = this.data.user.id_user;
    const id_level_profile = this.levelProfile.id_level_profile;

    this._levelProfileOfficialService
      .create(id_user, id_level_profile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response) => {
          if (response) {
            this._notificationService.success(
              'Funcionario agregado correctamente'
            );
          } else {
            this._notificationService.error(
              'Ocurrió un error agregando el funcionario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
   * updateOfficialField
   */
  updateOfficialField(index: number) {
    const officialsFormArray = this.levelProfileForm.get(
      'officials'
    ) as FormArray;

    const id_user = this.data.user.id_user;
    let levelProfileOfficial = officialsFormArray.getRawValue()[index];

    let officialUpdate = this.categoriesOfficial.find(
      (item) => item.id_official == levelProfileOfficial.id_official
    );

    levelProfileOfficial = {
      ...levelProfileOfficial,
      id_user_: parseInt(id_user),
      id_level_profile_official: parseInt(
        levelProfileOfficial.id_level_profile_official
      ),
      level_profile: {
        id_level_profile: parseInt(
          levelProfileOfficial.level_profile.id_level_profile
        ),
      },
      official: {
        id_official: parseInt(officialUpdate!.id_official),
      },
    };

    delete levelProfileOfficial.id_official;
    /**
     * Update the levelProfileOfficial
     */
    this._levelProfileOfficialService
      .update(levelProfileOfficial)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: any) => {
          if (response) {
            this._notificationService.success(
              'Fucionario actualizado correctamente'
            );
          } else {
            this._notificationService.error(
              'Ocurrió un error actualizando el fucionario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
  /**
   * updateOfficialModifier
   */
  updateOfficialModifier(index: number) {
    const officialsFormArray = this.levelProfileForm.get(
      'officials'
    ) as FormArray;

    const id_user = this.data.user.id_user;
    let levelProfileOfficial = officialsFormArray.getRawValue()[index];

    let officialUpdate = this.categoriesOfficial.find(
      (item) => item.id_official == levelProfileOfficial.id_official
    );

    levelProfileOfficial = {
      ...levelProfileOfficial,
      id_user_: parseInt(id_user),
      id_level_profile_official: parseInt(
        levelProfileOfficial.id_level_profile_official
      ),
      level_profile: {
        id_level_profile: parseInt(
          levelProfileOfficial.level_profile.id_level_profile
        ),
      },
      official: {
        id_official: parseInt(officialUpdate!.id_official),
      },
    };

    delete levelProfileOfficial.id_official;
    /**
     * Update the levelProfileOfficial
     */
    this._levelProfileOfficialService
      .update(levelProfileOfficial)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: any) => {
          if (!response) {
            this._notificationService.error(
              'Ocurrió un error actualizando el fucionario'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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
  /**
   * Remove the officials field
   * @param index
   */
  removeOfficialField(index: number): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar official',
        message:
          '¿Estás seguro de que deseas eliminar este official? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const officialsFormArray = this.levelProfileForm.get(
            'officials'
          ) as FormArray;
          /**
           * Get the current _levelProfileOfficialService
           */
          const id_user = this.data.user.id_user;
          const idLevelProfileOfficial =
            officialsFormArray.getRawValue()[index].id_level_profile_official;
          /**
           * Delete the _levelProfileOfficialService
           */
          this._levelProfileOfficialService
            .delete(id_user, idLevelProfileOfficial)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  this._notificationService.success(
                    'Funcionario eliminado correctamente'
                  );
                } else {
                  this._notificationService.error(
                    'Ocurrió un error eliminando el funcionario'
                  );
                }
                /**
                 * Mark for check
                 */
                this._changeDetectorRef.markForCheck();
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
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
