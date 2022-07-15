import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { Subject, takeUntil } from 'rxjs';
import { DocumentationProfileAttachedService } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.service';
import { DocumentationProfileAttached } from '../../documentation-profile/documentation-profile-attached/documentation-profile-attached.types';
import { documentationProfile } from '../../documentation-profile/documentation-profile.data';
import { DocumentationProfile } from '../../documentation-profile/documentation-profile.types';
import { ItemService } from '../../item/item.service';
import { Item } from '../../item/item.types';
import { TemplateControlService } from '../../template/template-control/template-control.service';
import { TemplateControl } from '../../template/template-control/template-control.types';
import { TemplateService } from '../../template/template.service';
import { Template } from '../../template/template.types';
import { ModalTaskRealizeService } from './modal-task-realize.service';

@Component({
  selector: 'app-modal-task-realize',
  templateUrl: './modal-task-realize.component.html',
})
export class ModalTaskRealizeComponent implements OnInit {
  id_template: string = '';
  taskRealizeForm!: FormGroup;
  id_company: string = '';

  listDocumentationProfile: DocumentationProfile[] = [];
  selectedDocumentationProfile: DocumentationProfile = documentationProfile;

  listItem: Item[] = [];

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  template!: Template;
  private data!: AppInitialData;
  templateForm!: FormGroup;

  templateControl!: TemplateControl[];
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _formBuilder: FormBuilder,
    private _modalTaskRealizeService: ModalTaskRealizeService,
    private _changeDetectorRef: ChangeDetectorRef,
    private _layoutService: LayoutService,
    private _templateService: TemplateService,
    private _templateControlService: TemplateControlService,
    private _documentationProfileAttachedService: DocumentationProfileAttachedService,
    private _itemService: ItemService
  ) {}

  ngOnInit(): void {
    this.id_template = this._data.id_template;

    /**
     * readAllItem
     */
    this._itemService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((items: Item[]) => {
        this.listItem = items;
      });

    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * form
     */
    this.taskRealizeForm = this._formBuilder.group({});
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
      lotAttached: this._formBuilder.array([]),
    });
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
     * Get the template
     */
    this._templateService
      .specificRead(this.id_template)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
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

        /**
         * Subscribe byTemplateRead
         */
        this._templateControlService
          .byTemplateRead(this.template.id_template)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();
        /**
         * Subscribe templateControls$
         */
        this._templateControlService.templateControls$
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_templateControl: TemplateControl[]) => {
            this.templateControl = _templateControl;
            /**
             * Set controls
             */
            this.templateControl.map((_templateControl: any) => {
              if (
                _templateControl.control.type_control === 'input' ||
                _templateControl.control.type_control === 'textArea' ||
                _templateControl.control.type_control === 'radioButton' ||
                _templateControl.control.type_control === 'select' ||
                _templateControl.control.type_control === 'date'
              ) {
                this.taskRealizeForm.addControl(
                  _templateControl.control.form_name_control,
                  new FormControl(
                    _templateControl.control.initial_value_control,
                    [
                      _templateControl.control.required_control
                        ? Validators.required
                        : Validators.min(0),
                    ]
                  )
                );
              } else if (_templateControl.control.type_control === 'checkBox') {
                _templateControl.control.options_control.map((item: any) => {
                  this.taskRealizeForm.addControl(
                    `${_templateControl.control.form_name_control}${item.value}`,
                    new FormControl(null)
                  );
                });
              } else if (
                _templateControl.control.type_control === 'dateRange'
              ) {
                this.taskRealizeForm.addControl(
                  `${_templateControl.control.form_name_control}StartDate`,
                  new FormControl(
                    _templateControl.control.initial_value_control,
                    [
                      _templateControl.control.required_control
                        ? Validators.required
                        : Validators.min(0),
                    ]
                  )
                );
                this.taskRealizeForm.addControl(
                  `${_templateControl.control.form_name_control}EndDate`,
                  new FormControl(
                    _templateControl.control.initial_value_control,
                    [
                      _templateControl.control.required_control
                        ? Validators.required
                        : Validators.min(0),
                    ]
                  )
                );
              }
            });
          });
        /**
         * Render plugin_attached_process
         */
        if (this.template.plugin_attached_process) {
          this._documentationProfileAttachedService
            .byDocumentationProfileRead(
              this.template.documentation_profile.id_documentation_profile
            )
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(
              (
                _documentationProfileAttacheds: DocumentationProfileAttached[]
              ) => {
                /**
                 * Clear the lotAttached form arrays
                 */
                (this.templateForm.get('lotAttached') as FormArray).clear();

                const lotAttachedFormGroups: any = [];
                /**
                 * Iterate through them
                 */
                _documentationProfileAttacheds.forEach(
                  (_documentationProfileAttached: any, index: number) => {
                    /**
                     * Add control for the input file
                     */
                    this.taskRealizeForm.addControl(
                      'removablefile' + index,
                      new FormControl({
                        value: '',
                        disabled: false,
                      })
                    );
                    /**
                     * Create a element form group
                     */
                    lotAttachedFormGroups.push(
                      this._formBuilder.group({
                        id_documentation_profile_attached:
                          _documentationProfileAttached.id_documentation_profile_attached,
                        id_attached:
                          _documentationProfileAttached.attached.id_attached,
                        name_attached:
                          _documentationProfileAttached.attached.name_attached,
                        description_attached:
                          _documentationProfileAttached.attached
                            .description_attached,
                        length_mb_attached:
                          _documentationProfileAttached.attached
                            .length_mb_attached,
                        required_attached:
                          _documentationProfileAttached.attached
                            .required_attached,
                        documentation_profile:
                          _documentationProfileAttached.documentation_profile,
                      })
                    );
                  }
                );
                /**
                 * Add the elemento form groups to the elemento form array
                 */
                lotAttachedFormGroups.forEach((lotAttachedFormGroup: any) => {
                  (this.templateForm.get('lotAttached') as FormArray).push(
                    lotAttachedFormGroup
                  );
                });
              }
            );
        }
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
  }
  get formArrayAttached(): FormArray {
    return this.templateForm.get('lotAttached') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.taskRealizeForm.patchValue({
      ...this.template,
      id_documentation_profile:
        this.template.documentation_profile.id_documentation_profile,
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
  }
  /**
   * closeModalTaskRealize
   */
  closeModalTaskRealize(): void {
    this._modalTaskRealizeService.closeModalTaskRealize();
  }
  /**
   * Track by function for ngFor loops
   *
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
