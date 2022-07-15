import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { documentationProfile } from '../../documentation-profile/documentation-profile.data';
import { DocumentationProfileService } from '../../documentation-profile/documentation-profile.service';
import { DocumentationProfile } from '../../documentation-profile/documentation-profile.types';
import { TemplateService } from '../template.service';
import { Template } from '../template.types';
import { ModalTemplateService } from './modal-template.service';

@Component({
  selector: 'app-modal-template',
  templateUrl: './modal-template.component.html',
  animations: angelAnimations,
})
export class ModalTemplateComponent implements OnInit {
  id_template: any;
  categoriesDocumentationProfile: DocumentationProfile[] = [];
  selectedDocumentationProfile: DocumentationProfile = documentationProfile;
  id_company: string = '';
  nameEntity: string = 'Plantilla';
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
  template!: Template;
  templateForm!: FormGroup;
  private templates!: Template[];

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
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _templateService: TemplateService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _documentationProfileService: DocumentationProfileService,
    private _modalTemplateService: ModalTemplateService
  ) {}

  ngOnInit(): void {
    this.id_template = this._data.id_template;
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
     * Create the template form
     */
    this.templateForm = this._formBuilder.group({
      id_template: [''],
      company: ['', [Validators.required]],
      id_documentation_profile: ['', [Validators.required]],
      plugin_item_process: ['', [Validators.required]],
      plugin_attached_process: ['', [Validators.required]],
      name_template: ['', [Validators.required, Validators.maxLength(100)]],
      description_template: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      status_template: ['', [Validators.required]],
      last_change: [''],
      in_use: [''],
    });
    /**
     * Get the templates
     */
    this._templateService.templates$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((templates: Template[]) => {
        this.templates = templates;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the template
     */
    this._templateService.template$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((template: Template) => {
        /**
         * Get the template
         */
        this.template = template;

        // DocumentationProfile
        this._documentationProfileService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((documentation_profiles: DocumentationProfile[]) => {
            this.categoriesDocumentationProfile = documentation_profiles;

            this.selectedDocumentationProfile =
              this.categoriesDocumentationProfile.find(
                (item) =>
                  item.id_documentation_profile ==
                  this.template.documentation_profile.id_documentation_profile.toString()
              )!;
          });

        /**
         * Patch values to the form
         */
        this.patchForm();
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
    this.templateForm.patchValue({
      ...this.template,
      id_documentation_profile:
        this.template.documentation_profile.id_documentation_profile,
    });
  }
  /**
   * closeModalTemplate
   */
  closeModalTemplate(): void {
    this._modalTemplateService.closeModalTemplate();
  }
  /**
   * Update the template
   */
  updateTemplate(): void {
    /**
     * Get the template
     */
    const id_user_ = this.data.user.id_user;
    let template = this.templateForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    template = {
      ...template,
      id_user_: parseInt(id_user_),
      id_template: parseInt(template.id_template),
      company: {
        id_company: parseInt(template.company.id_company),
      },
      documentation_profile: {
        id_documentation_profile: parseInt(template.id_documentation_profile),
      },
    };
    /**
     * Update
     */
    this._templateService
      .update(template)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_template: Template) => {
          if (_template) {
            this._notificationService.success(
              'Plantilla actualizada correctamente'
            );
            this.closeModalTemplate();
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
   * Delete the template
   */
  deleteTemplate(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar plantilla',
        message:
          '¿Estás seguro de que deseas eliminar esta plantilla? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current template's id
           */
          const id_user_ = this.data.user.id_user;
          const id_template = this.template.id_template;
          /**
           * Get the next/previous template's id
           */
          const currentIndex = this.templates.findIndex(
            (item) => item.id_template === id_template
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.templates.length - 1 ? -1 : 1);
          const nextId =
            this.templates.length === 1 &&
            this.templates[0].id_template === id_template
              ? null
              : this.templates[nextIndex].id_template;
          /**
           * Delete the template
           */
          this._templateService
            .delete(id_user_, id_template)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the template wasn't deleted...
                   */
                  this._notificationService.success(
                    'Plantilla eliminada correctamente'
                  );
                  this.closeModalTemplate();
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next template if available
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
